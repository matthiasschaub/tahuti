(()=>{function i(){let t=window.location.href.split("/");return t.pop()||t.pop(),t.pop()||t.pop()}document.body.addEventListener("htmx:configRequest",t=>{t.detail.path==="/apps/tahuti/api/version"||t.detail.path==="/apps/tahuti/api/our"||(site=`/apps/tahuti/api/groups/${i()}${t.detail.path}`,t.detail.path=site.replace(/\/$/,""))});var e=["add","expenses","balances","reimbursements","members","settings","about","invite"];for(let t=0;t<e.length;t++){let n=document.getElementById(`${e[t]}-href`);if(n!=null){let a=`/apps/tahuti/groups/${i()}/${e[t]}`;n.setAttribute("href",a)}}var p=document.getElementById("btn-invite");p!=null&&(p.action=`/apps/tahuti/groups/${i()}/invite`);})();
