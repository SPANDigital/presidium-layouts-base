---
date: '{{ .Date }}'
draft: true
author: 
title: '{{ replace .File.ContentBaseName `-` ` ` | title }}'
---
