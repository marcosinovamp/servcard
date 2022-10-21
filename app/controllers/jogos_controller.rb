class JogosController < ApplicationController

  def home
  end

  def card
    @card = Card.find(params[:id])
  end

  def game
    @player1 = Player.new(nome: params[:player1], nature: "human")
    @player1.save
    @player2 = Player.new(nome: "computer adversary", nature: "computer")
    @player2.save
    @game = Game.new(player1: @player1, player2: @player2)
    @game.save
    @cards = Card.all
    @stack1 = []
    @stack2 = []
    until @stack1.size == 12
      card = @cards.sample.id
      if @stack1.include?(card) == false
        @stack1 << card
      end
    end
    until @stack2.size == 12
      card2 = @cards.sample.id
      if @stack1.include?(card2) == false && @stack2.include?(card2) == false
        @stack2 << card2
      end
    end
  end

  def rascunho
  end

end

