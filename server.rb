require 'pg'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'


def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end


  get '/recipes' do
    query = "SELECT recipes.name FROM recipes ORDER BY name ASC"
    db_connection do |conn|
    @recipes_list = conn.exec(query)
    end

    erb :'recipe'
  end

