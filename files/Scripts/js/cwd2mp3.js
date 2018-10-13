#!/usr/bin/env node

/* Converts all files in the current working directory to mp3, using ffmpeg and libmp3lame */

'use strict';
const fs = require('fs');
const child_process = require('child_process');
const path = require('path');

fs.readdir(process.cwd(), (err, files) => {
  files.forEach(filename => {
    child_process.exec(`ffmpeg -i "${filename}" -codec:a libmp3lame -qscale:a 0 "${path.basename(filename)}.mp3"`)
  });
});

