# frozen_string_literal: true

class SessionsController < ApplicationController
  def sign_out
    session[SignInWithGoogle::KEY] = nil
    redirect_to root_path, notice: 'You are signed out'
  end
end
