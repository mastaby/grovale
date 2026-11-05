(()=>{const clean=()=>document.querySelectorAll('.cod-summary').forEach(node=>node.remove());new MutationObserver(clean).observe(document.body,{childList:true,subtree:true});clean()})();
