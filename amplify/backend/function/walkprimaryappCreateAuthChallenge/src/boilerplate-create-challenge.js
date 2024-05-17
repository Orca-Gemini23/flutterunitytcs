/**
 * @type {import('@types/aws-lambda').CreateAuthChallengeTriggerHandler}
 */
exports.handler = async (event) => {
  if (event.request.session.length === 2 && event.request.challengeName === 'CUSTOM_CHALLENGE') {
    event.response.publicChallengeParameters = { trigger: 'true' };

    event.response.privateChallengeParameters = {};
    event.response.privateChallengeParameters.answer = process.env.CHALLENGEANSWER;
  }
  return event;
};

exports.handler = async (event, context, callback) => {
  console.log(event.request);
 
  // If user is not registered
  if (event.request.userNotFound) {
      event.response.issueToken = false;
      event.response.failAuthentication = true;
      throw new Error("User does not exist");
  }
 
  if (event.request.session.length >= 3 && event.request.session.slice(-1)[0].challengeResult === false) { // wrong OTP even After 3 sessions?
      event.response.issueToken = false;
      event.response.failAuthentication = true;
      throw new Error("Invalid OTP");
  } else if (event.request.session.length > 0 && event.request.session.slice(-1)[0].challengeResult === true) { // Correct OTP!
      event.response.issueTokens = true;
      event.response.failAuthentication = false;
  } else { // not yet received correct OTP
      event.response.issueTokens = false;
      event.response.failAuthentication = false;
      event.response.challengeName = 'CUSTOM_CHALLENGE';
  }
 
  return event;
};


const AWS = require('aws-sdk');


function sendSMS(phone, code) {
    const params = {
      Message: code, /* required */
      PhoneNumber: phone,
    };
   
    return new AWS.SNS({apiVersion: '2010-03-31'}).publish(params).promise();
}


exports.handler = async (event) => {
    console.log("CUSTOM_CHALLENGE_LAMBDA", event.request);
   
    let secretLoginCode;
    if (!event.request.session || !event.request.session.length) {


        // Generate a new secret login code and send it to the user
        secretLoginCode = Date.now().toString().slice(-4);
        try {
            await sendSMS(event.request.userAttributes.phone_number, secretLoginCode);
        } catch {
           // Handle SMS Failure  
        }
    } else {


        // re-use code generated in previous challenge
        const previousChallenge = event.request.session.slice(-1)[0];
        secretLoginCode = previousChallenge.challengeMetadata.match(/CODE-(\d*)/)[1];
    }
   
    console.log(event.request.userAttributes);
   
    // Add the secret login code to the private challenge parameters
    // so it can be verified by the "Verify Auth Challenge Response" trigger
    event.response.privateChallengeParameters = { secretLoginCode };


    // Add the secret login code to the session so it is available
    // in a next invocation of the "Create Auth Challenge" trigger
    event.response.challengeMetadata = `CODE-${secretLoginCode}`;
   
    return event;
};


exports.handler = async (event) => {
  console.log(event.request);
 
  const expectedAnswer = event.request.privateChallengeParameters.secretLoginCode;
  if (event.request.challengeAnswer === expectedAnswer) {
      event.response.answerCorrect = true;
  } else {
      event.response.answerCorrect = false;
  }
 
  return event;
};
