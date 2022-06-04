# Instabug Backend challenge - May 2022

## Table of contents

<ul>
    <li><a href="#disclaimer">Disclaimer</a></li>
    <li><a href="#assumptions">Assumptions</a></li>
    <li><a href="#original-design">Original Design</a></li>
    <li><a href="#the-challenge">The Challenge</a></li>
    <li><a href="#final-design">Final Design</a></li>
    <li><a href="#run-command">Run Command</a></li>
    <li><a href="#run-command">Testing Commands</a></li>
    <li><a href="#next-steps">Next steps</a></li>
</ul>

## Disclaimer
I never used Ruby, RoR or RabbitMQ before and everything done in this task/repo is the result of alot of self-study and experimenting done over my time (besides working hours) over a week.

I have good knowledge in similar MVC platforms(e.g Django) and message brokers(Kafka) but they aren't exactly the same as the required technologies.

Please take that into consideration.

## Assumptions
no create men bara

## Original Design

## The Challenge

## Final Design
https://redis.io/docs/manual/transactions/#optimistic-locking-using-check-and-set
## Run Command

## Testing Commands
### Create applications endpoint
``curl --request POST \
  --url http://localhost:3000/applications/ \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "New application"
}'``

#### List applications endpoint
``curl --request GET \
  --url http://localhost:3000/applications/ \
  --header 'Content-Type: application/json'``

#### Retrieve applications endpoint
``curl --request GET \
  --url http://localhost:3000/applications/{APPLICATION_TOKEN}/ \
  --header 'Content-Type: application/json'``

#### Update applications endpoint
``curl --request PATCH \
  --url http://localhost:3000/applications/lva17pp7ub/ \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "Old application"
}'``

## Next steps
1. Apply linting to the whole project 
2. Add unit tests exposing success scenarios
3. Add unit tests exposing various failure scenarios
   a. Make sure Application create endpoint doesn't accept value for `token` and `char_count` fields
   b. Make sure Application create/get/update endpoint doesn't return the `id` field
   c. Make sure we don't have a `DELETE` endpoint for applications since it's not required
4. race conditions when we update application
5. 