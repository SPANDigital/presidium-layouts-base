---
date: {{ .Date }}
author: someone@example.com
title: '{{ replace .File.ContentBaseName `-` ` ` | title }}'
lastmod: :git
draft: true
---

Your content goes here.
