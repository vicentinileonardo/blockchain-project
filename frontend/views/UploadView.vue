<script lang="ts">
    function uploadToIPFS() {
        var fileField=document.getElementById("fileToUpload");
        if(fileField.files.length == 0 ){
            alert("No files selected");
        } else {
            const formData = new FormData();
            formData.append("file", fileField.files[0]);
            fetch("http://127.0.0.1:3000/api/uploadIPFS", {
                method: 'POST',
                body: formData,
            })
            .then(res => res.json())
            .then(data => document.getElementById("responseDiv").innerHTML=data.result[0].path)
        }
    }
</script>

<template>

    <h2>Upload a project</h2>
    <p>🔒 Secure the intellectual property of your project on the blockchain</p>
    <input type="file" id="fileToUpload">
    <button type="button" onclick="uploadToIPFS()">Upload</button>
    <br>
    <div id="responseDiv"></div>
</template>

<style scoped>

</style>