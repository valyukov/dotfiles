if filereadable(expand("~/.vimrc"))
  source ~/.vimrc
endif

autocmd! BufWritePost * Neomake
