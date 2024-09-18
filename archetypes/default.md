---
date: '{{ .Date }}'
draft: true
author: someone@example.com
title: '{{ replace .File.ContentBaseName `-` ` ` | title }}'
---
