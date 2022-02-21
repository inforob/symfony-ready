# fast install symfony applications


## install 
```ssh
make install APP=phpunit.it
```

## remove
```ssh
make remove APP=phpunit.it
```


### Mail RoundCube Fix Problem
```
service dovecot restart
```

### SSH KEYS
```
COPY .ssh/id_ed25519.pub /home/$user/.ssh/
COPY .ssh/id_ed25519 /home/$user/.ssh/
RUN chown -R $user:$user /home/$user/.ssh/
```