require 'pg'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'

###################################################
#                         Methods
###################################################

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

def all_recipes
  query = "SELECT * FROM recipes
            ORDER BY recipes.name ASC;"

  recipes = db_connection do |conn|
    conn.exec(query)
  end

  recipes.to_a
end

def recipe(id)
  query = "SELECT recipes.name AS name, recipes.instructions AS instructions, recipes.description AS description, ingredients.name AS ingredients, ingredients.recipe_id FROM recipes
    JOIN ingredients ON ingredients.recipe_id = recipes.id WHERE ingredients.recipe_id = '#{id}';"

  recipes = db_connection do |conn|
    conn.exec(query)
  end

  recipes.to_a
end

###################################################
#                    DATA
###################################################

get '/recipes' do
  @recipes_list = all_recipes

  erb :'recipe_list'
end

get '/recipes/:id' do
  @recipe_information = recipe(params[:id])

  erb :'recipe_info'
end
