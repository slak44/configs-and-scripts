#!/usr/bin/env node
'use strict';

require('http').createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end(process.argv.slice(2).join('\n'));
}).listen(3000);
