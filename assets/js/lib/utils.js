/**
 * A simple throttle version that ensures
 * the given function is called at most once
 * within the given time window.
 */
 export function throttle(fn, windowMs) {
    let ignore = false;
  
    return (...args) => {
      if (!ignore) {
        fn(...args);
        ignore = true;
        setTimeout(() => {
          ignore = false;
        }, windowMs);
      }
    };
  }