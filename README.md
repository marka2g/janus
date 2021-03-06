# [Janus, Roman God of Gates](https://en.wikipedia.org/wiki/Janus#:~:text=In%20ancient%20Roman%20religion%20and,depicted%20as%20having%20two%20faces.)
*a p.o.c. app for a json-only Authentication Api Built with Elixir and Phoenix*

### ToDo's
1. Gather requirments of existing Arcade implementation
2. implement `sign_out`
3. implement rails-reverse-proxy for existing output api `/v1/auth` akin to something discussed here: [Using phoenix with legacy rails app](https://littlelines.com/blog/2016/09/27/using-phoenix-with-a-legagy-rails-app)
4. segregate `sing_in`/`sign_out` into its own `SessionController`
5. implement `is_active` around subscriptions
6. implement a `/api/arcade` endpoint that can return a `current_user` and serve as a kind of `ping` to see if the user is still logged in. currently, arcade hits middleware on the output api for this

## Curl the API
>
> **Create a user:**
>
>> ```bash
>> curl -H "Content-Type: application/json" -X POST -d '{"user":{"email":"some@email.com","password":"some password"}}' http://localhost:4000/api/users
>> ```
>
> **Test the sign_in endpoint:**
>
>> *good creds:*
>>>```bash
>>> curl -H "Content-Type: application/json" -X POST -d '{"email":"user1@asd.com","password":"1resu"}' http://localhost:4000/api/users/sign_in -i
>>>```
>>> #=>
>>>```bash
>>> HTTP/1.1 200 OK
>>> cache-control: max-age=0, private, must-revalidate
>>> content-length: 78
>>> content-type: application/json; charset=utf-8
>>> date: Sun, 06 Jun 2021 21:05:54 GMT
>>> server: Cowboy
>>> x-request-id: FoYaOm2Yl-rC6gwAAACB
>>> 
>>> {"data":{"email":"user1@asd.com",>>> "id":"7ee19840-e5d1-40ac-8b38-b58ae29e5164"}}
>>>```
>
>> *bad creds:*
>>>```bash
>>> curl -H "Content-Type: application/json" -X POST -d '{"email":"user1@asd.com","password":"bad password"}' http://localhost:4000/api/users/sign_in -i
>>>```
>>> #=>
>>>```bash
>>> HTTP/1.1 401 Unauthorized
>>> cache-control: max-age=0, private, must-revalidate
>>> content-length: 47
>>> content-type: application/json; charset=utf-8
>>> date: Sun, 06 Jun 2021 21:10:01 GMT
>>> server: Cowboy
>>> x-request-id: FoYac9-eU7jkP7kAAAJE
>>> 
>>> {"errors":{"detail":"Wrong email or password"}}
>>>```
>
> **Test the sign_in endpoint** with cookies. `-c cookies.txt -b cookies.txt -i` how we enable cookies with curl which give us session support
> 
>> *bad creds:*
>>>```bash
>>> curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/users -c cookies.txt -b cookies.txt -i
>>>```
>>> #=>
>>>```bash
>>> HTTP/1.1 401 Unauthorized
>>> cache-control: max-age=0, private, must-revalidate
>>> content-length: 44
>>> content-type: application/json; charset=utf-8
>>> date: Sun, 06 Jun 2021 22:00:04 GMT
>>> server: Cowboy
>>> x-request-id: FoYdL4dfMtDkP7kAAABC
>>> 
>>> {"errors":{"detail":"Wrong email or password"}}
>>>```
>
>> *good creds:*
>>>```bash
>>> curl -H "Content-Type: application/json" -X POST -d '{"email":"user1@asd.com","password":"1resu"}' http://localhost:4000/api/users/sign_in -c cookies.txt -b cookies.txt -i
>>>```
>>> #=>
>>>```bash
>>> HTTP/1.1 200 OK
>>> cache-control: max-age=0, private, must-revalidate
>>> content-length: 78
>>> content-type: application/json; charset=utf-8
>>> date: Sun, 06 Jun 2021 22:03:39 GMT
>>> server: Cowboy
>>> x-request-id: FoYdYWwoUurBqs4AAACC
>>> set-cookie: _janus_key=SFMyNTY.g3QAAAABbQAAAA9jdXJyZW50X3VzZXJfaWRtAAAAJDdlZTE5ODQwLWU1ZDEtNDBhYy04YjM4LWI1OGFlMjllNTE2NA.pnxriFR5TS51lBvU4DIj_sBcvYHv4NWm7A0naq-iLEg; path=/; HttpOnly
>>>
>>> {"data":{"email":"user1@asd.com","id":"7ee19840-e5d1-40ac-8b38-b58ae29e5164"}}
>>>```
>>
>> *now, if u try requesting the resource again, you'll see:*
>> 
>>>```bash
>>> curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/users -c cookies.txt -b cookies.txt -i
>>>```
>>> #=>
>>>```bash
>>> HTTP/1.1 200 OK
>>> cache-control: max-age=0, private, must-revalidate
>>> content-length: 362
>>> content-type: application/json; charset=utf-8
>>> date: Sun, 06 Jun 2021 22:11:06 GMT
>>> server: Cowboy
>>> x-request-id: FoYdyXnDqWSpXQgAAAJB
>>>```
>>>```json
>>> {"data":[{"email":"user1@asd.com","id":"7ee19840-e5d1-40ac-8b38-b58ae29e5164","is_active":false},{"email":"user2@asd.com","id":"10f3d8a0-2431-4bb8-b3c8-b7d77e6f3d94","is_active":false},{"email":"user3@asd.com","id":"150442fc-a7c7-4640-b2cc-c30790363110","is_active":false},{"email":"user4@asd.com","id":"5a2ce641-8b9b-41a4-bd55-c95fe003771c","is_active":false}]}
>>>```
>
> **List users:**
>
>>>```bash
>>> curl -X GET "Content-Type: application/json" http://localhost:4000/api/users
>>>```
>>> #=> 
>>>```json
>>> {"data":[{"email":"user1@asd.com","id":"7ee19840-e5d1-40ac-8b38-b58ae29e5164","is_active":false},{"email":"user2@asd.com","id":"10f3d8a0-2431-4bb8-b3c8-b7d77e6f3d94","is_active":false},{"email":"user3@asd.com","id":"150442fc-a7c7-4640-b2cc-c30790363110","is_active":false},{"email":"user4@asd.com","id":"5a2ce641-8b9b-41a4-bd55-c95fe003771c","is_active":false}]}
>>>```
>
> **Find a user:**
>
>>>```bash
>>> curl -X GET "Content-Type: application/json" http://localhost:4000/api/users/7ee19840-e5d1-40ac-8b38-b58ae29e5164
>>>```
>>> #=> 
>>> ```json
>>>{"data":[{"email":"user1@asd.com","id":"7ee19840-e5d1-40ac-8b38-b58ae29e5164","is_active":false}}%
>>>```
>
---
## Build Steps and Commands
> 1. create the project:
>  
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
>> - `Subscribers` is the context???s(api boundry's) module name
>> - `User` is the schema???s module name
>> - `users` is the DB table???s name
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
>
> a note on `bcrypt_elixir` v. `pbkdf2_elixir`.  i went with `pbkdf2_elixir` because there are [issues with the underlying nifs on gcp compute engine](https://elixirforum.com/t/deployment-to-google-compute-engine/20409)
> 
> 7. generate the Users json endpoint.  note the `--no-context` and `--no-schema` opts
> 
>> $ `mix phx.gen.json Subscribers User users email:string password:string is_active:boolean --no-context --no-schema`
>> 
>> #=>
>>>  creating lib/janus_web/controllers/user_controller.ex
>>> creating lib/janus_web/views/user_view.ex
>>> creating test/janus_web/controllers/user_controller_test.exs
>>> creating lib/janus_web/views/changeset_view.ex
>>> creating lib/janus_web/controllers/fallback_controller.ex
>>> 
>>> Add the resource to your :api scope in lib/janus_web/router.ex:
>>> 
>>>  `resources "/users", UserController, except: [:new, :edit]`
>
> how to create a subscriber. for curl, see the `Curl the API` section above
> 
>> **on a `iex -S mix` console:**
>> 
>> $ `Janus.Subscribers.create_user(%{email: "asd@asd.com", password: "qwerty"})`
>> #=>
>>> ```elixir
>>> [debug] QUERY OK db=8.6ms decode=1.7ms queue=0.9ms idle=1671.2ms
>>> INSERT INTO "users" ("email","is_active","password_hash","inserted_at","updated_at","id") VALUES ($1,$2,$3,$4,$5,$6) ["asd@asd.com", false, "$pbkdf2-sha512$160000$AOSB9u7vslTK6oF6VIFHUg$GmyTO0NFrXRs21VEUrj.BFdVi1mtTNcYCJHmdnrSPL1GvirYW8u8GQl4C54H02xRAJefnDoivD9jr7Ty75TMZg", ~U[2021-06-06 19:59:21.179695Z], ~U[2021-06-06 19:59:21.179695Z], <<47, 91, 54, 107, 44, 174, 77, 139, 167, 40, 115, 73, 20, 173, 168, 76>>]
>>> 
>>> {:ok,
>>> %Janus.Subscribers.User{
>>>   __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
>>>   email: "asd@asd.com",
>>>   id: "2f5b366b-2cae-4d8b-a728-734914ada84c",
>>>  inserted_at: ~U[2021-06-06 19:59:21.179695Z],
>>>  is_active: false,
>>>  password: "qwerty",
>>>  password_hash: "$pbkdf2-sha512$160000$AOSB9u7vslTK6oF6VIFHUg$GmyTO0NFrXRs21VEUrj.BFdVi1mtTNcYCJHmdnrSPL1GvirYW8u8GQl4C54H02xRAJefnDoivD9jr7Ty75TMZg",
>>>  type: nil,
>>>  updated_at: ~U[2021-06-06 19:59:21.179695Z],
>>>  wordpress_id: nil
>>> }}
>>> ```
>
> added seeds, run seeds `mix run priv/repo/seeds.exs`


---
### Links of Interest

#### Security
[prevent a session fixation attack](https://owasp.org/www-community/attacks/Session_fixation)

[info on CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)

[corsica hex lib with the CorsPlug](https://hexdocs.pm/corsica/Corsica.html)

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

#### JWT v. Sessions
##### pro sessions
> [Why JWTs are Bad](https://www.youtube.com/watch?v=GdJ0wFi1Jyo&t=682s)
> 
> [Stop Using JWT for Sessions](http://cryto.net/~joepie91/blog/2016/06/13/stop-using-jwt-for-sessions/)

##### pro JWT
#### Auththentication with Phoenix
>[Phoenix.Token for API or Channels Authentication](https://hexdocs.pm/phoenix/Phoenix.Token.html)
>
>[Simple token authentication for Phoenix API](https://dev.to/mnishiguchi/simple-token-authentication-for-phoenix-json-api-1m05)
>
>[Combining authentication solutions with Guardian and Phx Gen Auth](https://fullstackphoenix.com/tutorials/combining-authentication-solutions-with-guardian-and-phx-gen-auth)
>> [multi-tenancy-and-authentication-with-pow p1](https://fullstackphoenix.com/tutorials/multi-tenancy-and-authentication-with-pow)
>
>[ridiculously-fast-api-authentication-with-phoenix](https://www.cloudbees.com/blog/ridiculously-fast-api-authentication-with-phoenix)
>
>[API Authentication with Phoenix and React ??? part 1](https://medium.com/@tommyblue/api-authentication-with-phoenix-and-react-part-1-30c6865bfbd3)
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
> [Auth as a Microservice](https://www.youtube.com/watch?v=SLc3cTlypwM)
>
> [Randall Degges - Everything You Ever Wanted to Know About Web Authentication in Node](https://www.youtube.com/watch?v=i7of02icPyQ)
>
> [Authorization for Applications & APIs](https://www.youtube.com/watch?v=-a7JbXL0hq0)
>

---
### Phoenix boiler plate

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
