# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_19_130739) do
  create_table "cards", force: :cascade do |t|
    t.string "nome"
    t.float "digitalizacao"
    t.boolean "botao_iniciar"
    t.integer "api_id"
    t.float "aprovacao"
    t.integer "avaliacoes"
    t.integer "etapas"
    t.integer "tempo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unidade"
    t.integer "duracao"
    t.integer "deck_id"
    t.string "identificacao"
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "nome"
    t.integer "siorg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo"
    t.string "sigla"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player1"
    t.integer "player2"
    t.integer "winner"
  end

  create_table "hands", force: :cascade do |t|
    t.integer "cardp1"
    t.integer "cardp2"
    t.integer "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id"
    t.index ["game_id"], name: "index_hands_on_game_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "nature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
  end

  create_table "stacks", force: :cascade do |t|
    t.integer "card1"
    t.integer "card2"
    t.integer "card3"
    t.integer "card4"
    t.integer "card5"
    t.integer "card6"
    t.integer "card7"
    t.integer "card8"
    t.integer "card9"
    t.integer "card10"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.integer "game_id"
    t.index ["game_id"], name: "index_stacks_on_game_id"
    t.index ["player_id"], name: "index_stacks_on_player_id"
  end

end
