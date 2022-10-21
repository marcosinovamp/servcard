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
    @game = Game.new(player1: @player1.id, player2: @player2.id)
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
    @hand = Hand.new(game_id: @game.id)
    @hand.save
    @stackp1 = Stack.new(game_id: @game.id, player_id: @player1.id, cards: @stack1)
    @stackp2 = Stack.new(game_id: @game.id, player_id: @player2.id, cards: @stack2)
    @stackp1.save
    @stackp2.save
  end

  def hand
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @stack1 = Stack.find_by(game_id: @game.id, player_id: @game.player1)
    @stack2 = Stack.find_by(game_id: @game.id, player_id: @game.player2)
    @player1 = Player.find(@stack1.player_id)
    @player2 = Player.find(@stack2.player_id)
    @cards_txt1 = @stack1.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @cards_txt2 = @stack2.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @st1 = @cards_txt1.split(",").map{|x| x.to_i}
    @st2 = @cards_txt2.split(",").map{|x| x.to_i}
    @hand.cardp1 = @st1.sample
    @hand.cardp2 = @st2.sample
    @hand.save
    @card = Card.find(@hand.cardp1)
    @cardadv = Card.find(@hand.cardp2)
  end

  def result
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @card1 = Card.find(@hand.cardp1)
    @card2 = Card.find(@hand.cardp2)
    @stack1 = Stack.find_by(game_id: @game.id, player_id: @game.player1)
    @stack2 = Stack.find_by(game_id: @game.id, player_id: @game.player2)
    @cards_txt1 = @stack1.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @cards_txt2 = @stack2.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @st1 = @cards_txt1.split(",").map{|x| x.to_i}
    @st2 = @cards_txt2.split(",").map{|x| x.to_i}
    if params[:caracteristica] == "total_de_avaliacoes"
      @char1 = @card1.avaliacoes.nil? ? 0 : @card1.avaliacoes
      @char2 = @card2.avaliacoes.nil? ? 0 : @card2.avaliacoes
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
     elsif params[:caracteristica] == "aprovacao_do_servico"
      @char1 = @card1.aprovacao.nil? ? 0 : @card1.aprovacao
      @char2 = @card2.aprovacao.nil? ? 0 : @card2.aprovacao
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "quantidade_de_etapas"
      @char1 = @card1.etapas
      @char2 = @card2.etapas
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "indice_de_digitalizacao"
      @char1 = @card1.digitalizacao.nil? ? 0 : @card1.digitalizacao
      @char2 = @card2.digitalizacao.nil? ? 0 : @card2.digitalizacao
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "botao_iniciar"
      @char1 = @card1.botao_iniciar == true ? "Sim" : "Não"
      @char2 = @card2.botao_iniciar == true ? "Sim" : "Não"
      if @char1 == "Sim"
        if @char2 == "Não"
          @hand.winner = @game.player1
          @st1 << @hand.cardp2
          @st2 = @st2 - [@hand.cardp2]
        else
          @hand.winner = 0
        end
      else
        if @char2 == "Sim"
          @hand.winner = @game.player2
          @st1 = @st1 - [@hand.cardp1]
          @st2 << @hand.cardp1
        else
          @hand.winner = 0
        end
      end
    else params[:caracteristica] == "tempo_de_espera"
      @char1 = @card1.duracao
      @char2 = @card2.duracao
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    end
    @stack1.cards = @st1.to_s
    @stack2.cards = @st2.to_s
    @stack1.save
    @stack2.save
  end

  def final_jogo
    @game = Game.find(params[:id])
  end

  def rascunho
  end

end

