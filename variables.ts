import Context from './fig/Context.js';

const variables = {
  get identity() {
    if (Context.attributes.username === 'alexander' ||
      Context.attributes.username === 'dutchcaffeine' ||
      Context.attributes.username === 'dc')
      return 'alexander';
    else
      return 'unknown';
  }
};

export default variables;
