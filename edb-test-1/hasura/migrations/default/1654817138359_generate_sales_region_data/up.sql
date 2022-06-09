update "order" set region = ((array[
  'NORTHEAST',
  'MIDWEST',
  'SOUTH',
  'PLAINS',
  'APPALACHIA',
  'MOUNTAIN',
  'NORTHWEST',
  'WEST',
  'SOUTHWEST'
  ])[floor(random()*9+1)])::text;
