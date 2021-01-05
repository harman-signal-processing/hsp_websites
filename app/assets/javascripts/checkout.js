const clientKey = document.getElementById("clientKey").innerHTML;

async function initCheckout() {
  try {
    const cartId = document.getElementById("cartId").innerHTML;
    const paymentMethodsResponse = await callServer("/checkout/" + cartId + "/get_payment_methods");
    const checkoutDetails = await callServer("/checkout/" + cartId + "/get_cart_details");

    const configuration = {
      paymentMethodsResponse,
      clientKey,
      locale: "en_US",
      environment: "test",
      showPayButton: true,
      paymentMethodsConfiguration: {
        ideal: {
          showImage: true,
        },
        card: {
          hasHolderName: true,
          holderNameRequired: true,
          amount: {
            value: checkoutDetails.total_cents,
            currency: checkoutDetails.currency,
          },
        },
      },
      onSubmit: (state, component) => {
        if (state.isValid) {
          handleSubmission(state, component, "/checkout/" + cartId + "/initiate_payment");
        }
      },
      onAdditionalDetails: (state, component) => {
        handleSubmission(state, component, "/checkout/" + cartId + "/submit_additional_details");
      },
    };

    const checkout = new AdyenCheckout(configuration);
    checkout.create("dropin").mount(document.getElementById("dropin"));
  } catch (error) {
    console.error(error);
    alert("Error occurred. Please try later.");
  }
}

// Event handlers called when the shopper selects the pay button,
// or when additional information is required to complete the payment
async function handleSubmission(state, component, url) {
  try {
    const res = await callServer(url, state.data);
    handleServerResponse(res, component);
  } catch (error) {
    console.error(error);
    alert("Error occurred. Please try later.");
  }
}

// Calls your server endpoints
async function callServer(url, data) {
  const res = await fetch(url, {
    method: "POST",
    body: data ? JSON.stringify(data) : "",
    headers: {
      "Content-Type": "application/json",
    },
  });

  return await res.json();
}

// Handles responses sent from your server to the client
function handleServerResponse(res, component) {
  if (res.action) {
    component.handleAction(res.action);
  } else {
    console.log(res);
    switch (res.resultCode) {
      case "Authorised":
        window.location.href = "/checkout/success";
        break;
      case "Pending":
      case "Received":
        window.location.href = "/checkout/pending";
        break;
      case "Refused":
        window.location.href = "/checkout/failed";
        break;
      default:
        window.location.href = "/checkout/error";
        break;
    }
  }
}

initCheckout();
