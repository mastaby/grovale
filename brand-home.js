const brandHome=()=>{const path=location.pathname.endsWith('/')?location.pathname:location.pathname;location.href=path};
document.addEventListener('click',event=>{const brand=event.target.closest('.brand-lockup,.admin-brand');if(!brand)return;event.preventDefault();brandHome()});
document.addEventListener('keydown',event=>{const brand=event.target.closest('.brand-lockup,.admin-brand');if(!brand||(event.key!=='Enter'&&event.key!==' '))return;event.preventDefault();brandHome()});
