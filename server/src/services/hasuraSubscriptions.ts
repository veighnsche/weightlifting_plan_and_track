let hasuraSubscriptions: Record<string, () => void> = {};

export function saveHasuraSubscription(subscriptionKey: string, subscription: () => void) {
  if (hasuraSubscriptions[subscriptionKey]) {
    hasuraSubscriptions[subscriptionKey]();
  }
  hasuraSubscriptions[subscriptionKey] = subscription;

  // count hasuraSubscriptions
  console.log("started hasuraSubscriptions", Object.keys(hasuraSubscriptions).length);
}

export function stopHasuraSubscription(subscriptionKey: string) {
  if (hasuraSubscriptions[subscriptionKey]) {
    hasuraSubscriptions[subscriptionKey]();
    delete hasuraSubscriptions[subscriptionKey];
  }

  // count hasuraSubscriptions
  console.log("stopped hasuraSubscriptions", Object.keys(hasuraSubscriptions).length);
}