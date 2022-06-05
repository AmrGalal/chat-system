# Instabug Backend challenge - May 2022

## Table of contents

<ul>
    <li><a href="#disclaimer">Disclaimer</a></li>
    <li><a href="#assumptions">Assumptions</a></li>
    <li><a href="#original-design">Original Design</a></li>
    <li><a href="#the-challenge">The Challenge</a></li>
    <li><a href="#run-command">Run Command</a></li>
    <li><a href="#testing-commands">Testing Commands</a></li>
    <li><a href="#next-steps">Next steps</a></li>
</ul>

## Disclaimer
I never used Ruby, RoR or RabbitMQ before and everything done in this task/repo is the result of alot of self-study and experimenting done over my time (besides working hours) over a week.

I have good knowledge in similar MVC platforms(e.g Django) and message brokers(Kafka) but they aren't exactly the same as the required technologies.

Please take that into consideration.

## Assumptions
I made a few assumptions that I want to clearly state.

1. All the operations done on the server will be done throughout the API endpoints I created. This means that the creation of chats/messages must be done through the endpoints in order to have the number property working correctly as expected. 
   
   However, we can have a workaround if we set the process of setting a number in the `before_create` callback

2. I won't have race conditions for the applications update endpoint. I put my focus regarding the race conditions to be for Message/Chat creation endpoint.

## Original Design

After looking at the requirements and understanding it, I put the following design into place.

Application creation has no challenge, just an endpoint that handles unique `token` creation.

Chat/Message creation endpoint will publish a message into a RabbitMQ queue indicating that we want to create a new object and return `200` to the frontend. Workers will consume the request then get value for the `number` field from Redis and create an object using this field. However, this had two problems:

1. We need to return the number in the endpoint which means that all the process of generating new number should be in the endpoint logic not the consumer logic
2. Race conditions can lead wrong numbers being generated for Chat/Message

Regarding the update of `chats_count` and `messages_count`, I will use a job scheduler that runs every 30 mins to update the count for each Application and Chat that I have in my database.
## The Challenges

To get through these challenges I modified my design abit.

The endpoint will now generate the number for the object and embed this number into the message we publish into queues so that I can return this number in the response.

This meant that I want to make sure no two requests wanting to create a chat for same application (or message for same chat) will return the same number twice.

Since am using redis to update the number, the problem boiled down to making sure that no two requests modify the same Redis key at the same time.

I know Redis handles this problem well by the usage of locks over keys using `watch` and `unwatch` commands so I decided to use that to get over the race conditions hump.

More info about this approach can be found in their documentation [here](https://redis.io/docs/manual/transactions/#optimistic-locking-using-check-and-set)

## Run Command
`docker-compose build && docker-compose up`

## Testing Commands
### Applications
#### Create application
``curl --request POST \
  --url http://localhost:3000/applications/ \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "New application"
}'``

#### List applications
``curl --request GET \
  --url http://localhost:3000/applications/ \
  --header 'Content-Type: application/json'``

#### Retrieve application
``curl --request GET \
  --url http://localhost:3000/applications/lva17pp7ub/ \
  --header 'Content-Type: application/json'``

#### Update application
``curl --request PATCH \
  --url http://localhost:3000/applications/lva17pp7ub/ \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "Old application"
}'``

### Chats
#### Create Chat
`curl --request POST \
  --url http://localhost:3000/applications/lva17pp7ub/chats/ \
  --header 'Content-Type: application/json'`
#### List Application's chats
`curl --request GET \
  --url http://localhost:3000/applications/lva17pp7ub/chats/`

### Messages
#### Create Message
`curl --request POST \
  --url http://localhost:3000/applications/lva17pp7ub/chats/1/messages/ \
  --header 'Content-Type: application/json' \
  --data '{
	"content": "helloo"
}'`
#### List Chat's messages
`curl --request GET \
  --url http://localhost:3000/applications/lva17pp7ub/chats/1/messages/`
#### Search Chat's messages
  curl --request POST \
  --url http://localhost:3000/applications/lva17pp7ub/chats/1/messages/search/ \
  --header 'Content-Type: application/json' \
  --data '{
	"content": "ell"
}'

## Next steps
1. Write specs for the code
2. Add a script in the docker compose command to wait for the DB and ES to fully get up
3. Apply linting to the whole project 
4. Add unit tests exposing success scenarios
5. Add unit tests exposing various failure scenarios
   a. Make sure Application create endpoint doesn't accept value for `token` and `char_count` fields
   b. Make sure Application create/get/update endpoint doesn't return the `id` field
   c. Make sure we don't have a `DELETE` endpoint for applications since it's not required
   etc.
6. Handle race conditions upon updating the application
 