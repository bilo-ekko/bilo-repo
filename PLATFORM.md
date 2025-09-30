A simplified platform for compensating to carbon contributions

Apps:

- Frontends
    - Dashboard
    - SDK renderer
        - impact-embedded
        - impact-page
        - checkout
- Backend:
    - Api Gateway
        - controllers that connect to the various services
- Services:
    - Auth Service
        - Stub for an auth service to be implemented later ... will likely use sessions etc.
    - Carbon Service
        - POST `/carbon/calculate`
            - input: POST body with transaction amount, currency, merchant category code, country
            - output: object with the relevant data, including carbon impact (grams and ounces)
        - GET `/carbon/quotes/:id`
            - input: the id that the endpoint `carbon/calculate` created
            - output: the full response / quote
        - GET `/carbon/equivalents?(grams|ounces)={number}`
            - input: the grams/ounces we want the equivalents for
            - output: an array to indicate the equivalents of the carbon impact, e.g.
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
        - POST `/payments/create`
            - input: Post body with card details (mocking the payment service)
            - output: success / error response