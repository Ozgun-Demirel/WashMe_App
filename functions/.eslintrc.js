module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
  "users": {
  "$uid" : {
  ".read": "true",
  ".write" : "$uid === auth.uid"}
  }
    quotes: ["error", "double"],
  },
};
