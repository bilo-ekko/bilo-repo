A simplified platform for compensating to carbon contributions

## Apps:

Frontends
- Hub (Next.js web dashboard app)
    - User management page
    - 
- SDK renderers (one for each app)
    - impact-embedded
    - impact-page
    - checkout

Backend:
- Api Gateway
    - controllers that connect to the various services

## Services:

- Auth Service
    - Stub for an auth service to be implemented later ... will likely use sessions etc.
- Calculation Service
    - **POST** `/carbon/calculate`
        - input: POST body with transaction amount, currency, merchant category code, country
        - output: object with the relevant data, including carbon impact (grams and ounces)
        - stack: Nest.js
    - **GET** `/carbon/quotes/:id`
        - input: the id that the endpoint `carbon/calculate` created
        - output: the full response/quote
        - stack:  Nest.js
        - response:
        ```js
        {
            

        }
        ```
    - **GET** `/carbon/equivalents?(grams|ounces)={number}`
        - input: the grams/ounces we want the equivalents for
        - output: an array to indicate the equivalents of the carbon impact, e.g.
        - stack: Nest.js
        - response:
        [
            // ...
            {
                key: 'tree_year',
                value: 2.3,
                description: '1 tree can absorb in 2.3 years'
            },
            // ...
        ]
- Payment Service
    - **POST** `/payments/create`
        - input: Post body with card details (mocking the payment service)
        - output: success / error response
        - stack: Nest.js