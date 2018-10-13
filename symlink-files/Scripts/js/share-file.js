#!/usr/bin/env node
'use strict';

const port = process.env.PORT || 3000;
const path = process.argv[2];
const mime = require('child_process').execSync(`xdg-mime query filetype ${path}`).toString().trim();
console.log(`Serving "${path}" as "${mime}" on ${port}`);

require('http').createServer((req, res) => {
  console.log(`Received ${req.method} request from ${req.socket.remoteAddress}`)
  if (req.url !== '/') {
    console.log(`Bad request, invalid url (only "/" path allowed): "${req.url}"`);
    res.statusCode = 400;
    res.end();
    return;
  }
  res.statusCode = 200;
  res.setHeader('Content-Type', mime);
  res.end(require('fs').readFileSync(path).toString());
}).listen(port);
