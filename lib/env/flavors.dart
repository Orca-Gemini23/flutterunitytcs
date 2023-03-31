// enum Environment { prod, stage, dev }

// abstract class Flavors {
//   static late String baseHasuraUrl;
//   static late String baseLambdaUrl;
//   static late String endPointLambdaUrl;
//   static late String hasuraKey;
//   static late bool prod;

//   static setupEnvironment(Environment env) {
//     switch (env) {
//       case Environment.prod:
//         {
//           hasuraKey =
//               "Sm4BFzJcUa5DnpoTmsZlPzK1sfJtayt2BBzE6N1Ui7haZ53Isn8njKBlFPT1r1WF";
//           baseHasuraUrl = "diverse-dodo-29.hasura.app";
//           baseLambdaUrl = "v8vejz4rh9.execute-api.ap-south-1.amazonaws.com";
//           endPointLambdaUrl = "/dev/App-validation";
//           prod = true;
//         }
//         break;

//       case Environment.stage:
//         {
//           hasuraKey =
//               "OD4xgAFVEehjLIKMEfVGHJlxX6z7O1dHccOBQEV8wT0zjtOLWebZqoqRbRNRyBcb";
//           baseHasuraUrl = "cw-stage.hasura.app";
//           baseLambdaUrl = "v8vejz4rh9.execute-api.ap-south-1.amazonaws.com";
//           endPointLambdaUrl = "/dev/app-validation-stage";
//           prod = false;
//         }
//         break;

//       default:
//         {
//           baseHasuraUrl = "diverse-dodo-29.hasura.app";
//           baseLambdaUrl = "vv8vejz4rh9.execute-api.ap-south-1.amazonaws.com";
//           endPointLambdaUrl = "/dev/App-validation";
//           prod = false;
//         }
//     }
//   }
// }
