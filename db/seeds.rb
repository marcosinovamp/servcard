# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "csv"
require "json"
require "open-uri"

url = "https://www.servicos.gov.br/api/v1/servicos"
rascunho = URI.open(url).read
servicos = JSON.parse(rascunho)

ids = []

servicos["resposta"].each do |s|
    if Deck.find_by(siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")).nil?
        @org = Deck.new({nome:s["orgao"]["nomeOrgao"], siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")})
        @org.save
    end
    if Card.find_by(api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "")).nil?
    @card = Card.new(nome:s["nome"], api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", ""), deck_id:Deck.find_by(siorg: s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")).id, digitalizacao:s["porcentagemDigital"], botao_iniciar: s["servicoDigital"], etapas: s["etapas"].size)
        if s["tempoTotalEstimado"]["ate"].nil? == false
            @card.tempo = s["tempoTotalEstimado"]["ate"]["max"].to_i
            @card.unidade = s["tempoTotalEstimado"]["ate"]["unidade"]
        elsif s["tempoTotalEstimado"]["entre"].nil? == false
            @card.tempo = s["tempoTotalEstimado"]["entre"]["max"].to_i
            @card.unidade = s["tempoTotalEstimado"]["entre"]["unidade"]
        elsif s["tempoTotalEstimado"]["atendimentoImediato"].nil? == false
            @card.tempo = 0
            @card.unidade = "dias"
        else
            @card.tempo = 999999999
            @card.unidade = "dias"
        end
        if s["avaliacoes"].nil?
            @card.aprovacao = 0
            @card.avaliacoes = 0
        else
            pos = s["avaliacoes"]["positivas"].nil? ? 0 : s["avaliacoes"]["positivas"].to_i
            neg = s["avaliacoes"]["negativas"].nil? ? 0: s["avaliacoes"]["negativas"].to_i
            @card.aprovacao = pos.to_f/(pos + neg)
            @card.avaliacoes = pos + neg
        end
        @card.save
    end
end