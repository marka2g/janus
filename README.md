
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
> 6. create users with a subscribers api boundry - *keep it simple for now*
> 
>> $ `mix phx.gen.context Subscribers User users type:string wordpress_id:string email:string:unique password_hash:string is_active:boolean`
>> 
>> - `Subscribers` is the context’s(api boundry's) module name
>> - `User` is the schema’s module name
>> - `users` is the DB table’s name
>> - Then what follows are some field definitions
>>
>> ...to get help with contexts: `mix help phx.gen.context`
>>
>> ...output #=>
>> creating lib/janus/subscribers/user.ex
>> creating priv/repo/migrations/20210606181528_create_users.exs
>> creating lib/janus/subscribers.ex
>> injecting lib/janus/subscribers.ex
>> creating test/janus/subscribers_test.exs
>> injecting test/janus/subscribers_test.exs
>
>> $ `mix ecto.migrate`

> a note on `bcrypt_elixir` v. `pbkdf2_elixir`.  i went with `pbkdf2_elixir` because there are [issues with the underlying nifs on gcp compute engine](https://elixirforum.com/t/deployment-to-google-compute-engine/20409)

---
### Links of Interest
#### Intergrating Rails
> [Using phoenix with legacy rails app](https://littlelines.com/blog/2016/09/27/using-phoenix-with-a-legagy-rails-app)
>
>[How we Built a Highly Performant App with Ruby on Rails and Phoenix](https://www.monterail.com/blog/ruby-on-rails-development-phoenix-elixir)

#### GCP Identity Platform
> [GCP Identity Platform - Docs](https://cloud.google.com/docs)
> 
> [Signin using the REST API - token & refresh token based signin](https://> cloud.google.com/identity-platform/docs/use-rest-api)
> 
> *Note: If your app uses a sign-in method that Identity Platform supports > (such as email and password), consider migrating users instead of > implementing custom authentication.*
> [login with custom auth system](https://cloud.google.com/identity-platform/> docs/web/custom)
#### GCP - Elixir
> [GCP - Elixir Phoenix on App Engine Official Tutorial](https://cloud.google.com/community/tutorials/elixir-phoenix-on-google-app-engine)
>
> [GCP - Elixir Phoenix on Cloudrun Official Tutorial](https://cloud.google.com/community/tutorials/elixir-phoenix-on-cloud-build-cloud-run)
>
> [Repository containing all the client libraries to interact with Google APIs](https://github.com/googleapis/elixir-google-api)
>
>[GCP Elixir Samples](https://github.com/GoogleCloudPlatform/elixir-samples)
>
>> [GCP Elixir Samples - Auth](https://github.com/GoogleCloudPlatform/elixir-samples/tree/master/auth)
>
>[GCP IAP - TCP Forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)
>
>[dont use bcrypt](https://stackoverflow.com/questions/54877692/issue-with-elixir-phoenix-on-google-compute-engine)
>
>[deployment thread](https://elixirforum.com/t/deployment-to-google-compute-engine/20409)
>
>[GCP Runtime on GCP](https://github.com/GoogleCloudPlatform/elixir-runtime)
>
>[logflare - nice streaming logs pipeline setup on gcp](https://github.com/Logflare/logflare)
>

#### Auth with Phoenix
>[Phoenix.Token for API or Channels Authentication](https://hexdocs.pm/phoenix/Phoenix.Token.html)
>
>[Simple token authentication for Phoenix API](https://dev.to/mnishiguchi/simple-token-authentication-for-phoenix-json-api-1m05)
>
>[Combining authentication solutions with Guardian and Phx Gen Auth](https://fullstackphoenix.com/tutorials/combining-authentication-solutions-with-guardian-and-phx-gen-auth)
>> [multi-tenancy-and-authentication-with-pow p1](https://fullstackphoenix.com/tutorials/multi-tenancy-and-authentication-with-pow)
>
>[ridiculously-fast-api-authentication-with-phoenix](https://www.cloudbees.com/blog/ridiculously-fast-api-authentication-with-phoenix)
>
>[API Authentication with Phoenix and React — part 1](https://medium.com/@tommyblue/api-authentication-with-phoenix-and-react-part-1-30c6865bfbd3)
>
>[ueberauth list of strategies](https://github.com/ueberauth/ueberauth/wiki/List-of-Strategies)
>
>[jwt elixir](https://njwest.medium.com/jwt-auth-with-an-elixir-on-phoenix-1-3-guardian-api-and-react-native-mobile-app-1bd00559ea51)
>
>[thoughtbot - ueberauth/oauth post](https://thoughtbot.com/blog/authentication-in-elixir-web-applications-with-ueberauth-and-guardian-part-4)
>
>[basic http auth in phoenix](https://nts.strzibny.name/basic-http-authentication-in-elixir-phoenix/)

#### Videos
>[A Gentle Intro to Elixir Phoenix on GCP](https://www.youtube.com/watch?v=sJR4j9WBSR0)
>

---
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
