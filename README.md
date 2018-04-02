# q_and_a

A "question and answer" Rails application which follows [TDD](https://en.wikipedia.org/wiki/Test-driven_development) and is architected with [Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html).

## Implementation

* Users can auth with Google Oauth2
  * Neither [devise](https://github.com/plataformatec/devise/), nor [omniauth](https://github.com/omniauth/omniauth), nor [warden](https://github.com/wardencommunity/warden) is used. They are overkill for a small application.
  * [app/entities/google_oauth2.rb](app/entities/google_oauth2.rb).
* Users can submit questions and answers to questions
  * User can also update/delete their own questions/answers, but cannot manipulate others' questions/answers.
* Both answers' and questions' bodies are rendered as Markdown
  * Utilized REXML to normalize HTML for testing.
  * [test/interactors/render_markdown_test.rb](test/interactors/render_markdown_test.rb)
* Questions can be searched by title, and body
  * PostgreSQL's full-text search with [cover density ranking](https://www.postgresql.org/docs/10/static/textsearch-controls.html#TEXTSEARCH-RANKING) feature is good enough. [Elasticsearch](https://github.com/elastic/elasticsearch) and [Solr](https://github.com/apache/lucene-solr) will be too heavy.
  * [db/migrate/20180401102820_add_search_vector_to_questions.rb](db/migrate/20180401102820_add_search_vector_to_questions.rb)
* Questions and Answers are paginated per 5 elements.
  * [app/entities/pagination.rb](app/entities/pagination.rb)
* Follow [AngularJS commit message conventions](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.uyo6cb12dt6w)

## Start Server

```
$ git clone git@github.com:tonytonyjan/q_and_a.git
$ cd q_and_a
$ echo OAUTH2_CLIENT_ID=YOUR_GOOGLE_OAUTH2_CLIENT_ID > .env
$ echo OAUTH2_CLIENT_SECRET=YOUR_GOOGLE_OAUTH2_CLIENT_SECRET >> .env
$ docker-compose run --rm setup # first time only
$ docker-compose up server
```

Open [http://localhost:3000](http://localhost:3000) after server started.

Pull the pre-built image at first if you don't want to build on your machine:

```
$ docker pull tonytonyjan/q_and_a
```

Remove volumes and restart service if the database is somehow corrupted.

```
$ docker-compose down -v
$ docker-compose run --rm setup
$ docker-compose up server
```

## Run Tests

```
$ docker-compose run --rm test
```
