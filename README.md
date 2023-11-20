# HelloID-Task-SA-Target-HelloID-AccountUpdateAttributes

## Prerequisites

- [ ] HelloID API key and secret
- [ ] Pre-defined variables: `portalBaseUrl`, `portalApiKey` and `portalApiSecret` created in your HelloID portal.

## Description

This code snippet will update an existing user within HelloID and executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties necessary to update an existing user within `HelloID`, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "userName": "john.doe",
    "firstName": "john",
    "lastName": "doe",
    "contactEmail": "johndoe@enyoi.org",
    "isEnabled": "true",
    "password": "P@ssw0rd1!",
    "mustChangePassword": "true",
    "employeeid": "12345678",
    "title": "tester",
    "department": "test",
    "phonenumber": "0612345678",
    "manager": {
        "UserGUID": "8a6b62fc-dca3-4890-bacd-3db76c5e9152"
    }
}
```
> Note: the 'userName' property serves as the identifier, indicating which user is being updated.
> 
> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hash table is appropriately adjusted to match your form fields.
> [See the HelloID API Docs page](https://apidocs.helloid.com/docs/helloid/b432862fd92c6-update-a-user)

2. Creates authorization headers using the provided API key and secret.

3. Update an existing using the: `Invoke-RestMethod` cmdlet. The hash table called: `$formObject` is passed to the body of the: `Invoke-RestMethod` cmdlet as a JSON object.