class JogosController < ApplicationController

  def home
  end

  def card
    @card = Card.find(params[:id])
  end

end

