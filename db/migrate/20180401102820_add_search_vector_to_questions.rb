# frozen_string_literal: true

class AddSearchVectorToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :search_vector, 'tsvector'

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE questions SET search_vector =
            setweight(to_tsvector('english', title), 'A') ||
            setweight(to_tsvector('english', content), 'B');
        SQL
      end
    end

    add_index :questions, :search_vector, using: :gin

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE FUNCTION questions_trigger() RETURNS trigger AS $$
          BEGIN
            new.search_vector :=
               setweight(to_tsvector('english', new.title), 'A') ||
               setweight(to_tsvector('english', new.content), 'B');
            return new;
          END
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER questions_search_vector_update
            BEFORE INSERT OR UPDATE
            ON questions
            FOR EACH ROW EXECUTE PROCEDURE questions_trigger();
        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER questions_search_vector_update ON questions;
          DROP FUNCTION questions_trigger;
        SQL
      end
    end
  end
end
