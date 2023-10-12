console.log("Loading all JavaScript files.");
console.table({
  'Time Stamp': new Date().getTime(),
  'OS': navigator['platform'],
  'Browser': navigator['appCodeName'],
  'Language': navigator['language'],
});
