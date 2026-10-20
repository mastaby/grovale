document.addEventListener('click',event=>{if(event.target.closest('.logo')){event.preventDefault();if(typeof window.goHome==='function')window.goHome()}});
