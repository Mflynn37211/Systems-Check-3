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

###################################################
#                    DATA
###################################################

get '/recipes' do
  query = "SELECT * FROM recipes
            ORDER BY recipes.name ASC;"

  recipes = db_connection do |conn|
    conn.exec(query)
  end

  @recipes_list = recipes.to_a

  erb :'recipe_list'
end

get '/recipes/:id' do
  query = "SELECT recipes.name AS name, recipes.instructions AS instructions, recipes.description AS description, ingredients.name AS ingredients, ingredients.recipe_id FROM recipes
    JOIN ingredients ON ingredients.recipe_id = recipes.id WHERE ingredients.recipe_id = '#{params[:id]}';"

  recipes = db_connection do |conn|
    conn.exec(query)
  end

  @recipe_information = recipes.to_a

  erb :'recipe_info'
end
