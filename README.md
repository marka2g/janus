
## Build Steps and Commands
> 1. create the project:
> 
>> [Janus, Greek God of Gates](https://en.wikipedia.org/wiki/Janus#:~:text=In%20ancient%20Roman%20religion%20and,depicted%20as%20having%20two%20faces.)
>> 
>> $ `mix phx.new janus --app janus --module Janus --no-html --no-webpack --binary-id`
>  
>>> a. `janus` is the name of the app and dir that's created
>> 
>>> b. `Janus` is used as the main module in the app
>
>>> c. this is not a typical app, it's just a json api, i.e. the `--no-html --no-webpack` options.  so, don't worry if u see error pages when `mix phx.server`
> 
> 2. cd into proj, set the db `username` and `password` in `config/dev.exs` to match ur local db and then create the dev db by running:
> 
>> $ `mix ecto.create`
> 
> 3. update db creds in `config/dev.exs`
> 
> 4. generate an `Accounts` context to segregate a clean api boundry in dealing with users
> 
> build the API Boundry Context
> 
> 5. start the server, check it out at `[localhost:4000](http://localhost:4000/dashboard)` to see if it all worked
> 
>> $ `mix phx.server`
>
>

---
#### Phoenix boiler plate

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
