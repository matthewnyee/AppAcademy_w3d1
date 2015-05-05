require 'byebug'
# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    SELECT
      title
      FROM
        movies
      JOIN
        castings ON movies.id = castings.movie_id
      JOIN
        actors ON castings.actor_id = actors.id
      WHERE
        actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    title
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Harrison Ford' AND castings.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    SELECT
      title, actors.name
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      castings.ord = 1 AND movies.yr = 1962
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    yr, COUNT(title)
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'John Travolta'
  GROUP BY
    yr
  HAVING
    count(title) >= 2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    SELECT
       movies.title, a2.name
    FROM
      actors AS a1
    JOIN
      castings as c1 ON a1.id = c1.actor_id
    JOIN
      movies ON c1.movie_id = movies.id
    -- WHERE
      -- a1.name = 'Julie Andrews'
    JOIN
      castings AS c2 ON movies.id = c2.movie_id
    JOIN
      actors AS a2 ON c2.actor_id = a2.id
    WHERE
      a1.name = 'Julie Andrews' AND
      c2.ord = 1
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT
    a1.name
  FROM
    actors AS a1
  JOIN
    castings as c1 ON a1.id = c1.actor_id
  JOIN
    movies ON c1.movie_id = movies.id
  -- JOIN
  --   castings AS c2 ON movies.id = c2.movie_id
  -- JOIN
  --   actors AS a2 ON c2.actor_id = a2.id
  WHERE
    c1.ord = 1
  GROUP BY
    a1.id
  HAVING
    COUNT(movies.title) >= 15
  ORDER BY
    a1.name
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    SELECT
      title, count(actor_id)
    FROM
      movies
    JOIN
      castings on castings.movie_id = movies.id
    WHERE
      yr = 1978
    GROUP BY
      movie_id
    ORDER BY
      COUNT(actor_id), title
    --
    -- SELECT
    --   count(actor_id)
    -- FROM
    --   castings
    -- GROUP BY
    --   movie_id
    -- ORDER BY
    --   COUNT(actor_id)

  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SQL
end

p films_by_cast_size
