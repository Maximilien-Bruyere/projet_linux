

myhostname = mail.srv.world #95
mydomain = srv.world #102
myorigin = $mydomain #118
inet_interfaces = all #135
inet_protocols = ipv4 #138
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain #183
mynetworks = 127.0.0.0/8, 10.0.0.0/24 #283
home_mailbox = Maildir/ #438
smtpd_banner = $myhostname ESMTP #593

---

listen = *, :: #30

------

disable_plaintext_auth = no #10
auth_mechanisms = plain login #100

------

mail_location = maildir:~/Maildir #30
# Postfix smtp-auth
  unix_listener /var/spool/postfix/private/auth { #107-109
    mode = 0666
    user = postfix
    group = postfix
  }

------

ssl = yes