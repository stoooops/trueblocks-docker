import * as da from './actions';
const Utils = require('../../utils');

//----------------------------------------------------------------------
export const dispatcher_Dashboard = (action) => {
  return (dispatch, getState) => {
    dispatch({
      type: da.BEGIN
    });

    var res = action.split('/');
    return Utils.queryAPI_get(res[0], res[1])
      .then(async (result) => {
        let json = await result.json();
        if (json.errors) {
          throw json.errors[0];
        } else {
          dispatch({
            type: action,
            payload: json.data
          });
        }
      })
      .catch((err) => {
        dispatch({
          type: da.FAILURE,
          err
        });
      });
  };
};

// EXISTING_CODE
// EXISTING_CODE