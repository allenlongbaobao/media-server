$(function () {
  if (window.File && window.FileReader && window.FileList && window.Blob) {
    console.log("Fine..");
  } else {
    console.log("The File APIs are not fully supported in this browser.")
  }
 
  var $message = $("p#message");
  var $avatar = $("img#avatar");
  // var imageAreaSelect = $("img#avatar").imgAreaSelect({instance: true});
  var selectArea = {
    x: 0,
    y: 0,
    cropwidth: 0,
    cropheight: 0
  };
  // imageAreaSelect.setOptions({
  //   aspectRatio:"1:1",
  //   fadeSpeed: true,
  //   minHeight: 50,
  //   maxHeight: 500,
  //   handles: true,
  //   onSelectEnd: handleAreaSelect
  // });

  function handleFileSelect (evt) {
    evt.preventDefault();
    //var $output = $("#output");
    var file = evt.target.files[0];
    if (!file) {
      console.log("Nothing happened..");
    } else if (!file.type.match('image.*')) {
      alert("Only process image files.");
    } else {
      showLoadingMessage();
      loadImageAndDisplay(file);
    }
  }

  function showLoadingMessage () {
    $message.html("正在读取").show();
  }
  
  function loadImageAndDisplay (file) {
    var reader = new FileReader();
    reader.onload = function (e) {
      displayImage(e.target.result);
      // restartAreaSelect();
    };
    reader.readAsDataURL(file);
  }

  function displayImage (src) {
    $message.hide();
    $avatar.attr('src', src).show();
  }

  function restartAreaSelect () {
    imageAreaSelect.cancelSelection();
    imageAreaSelect.update();
  }
  
  function handleAreaSelect (image, position) {
    selectArea.cropwidth = position.width;
    selectArea.cropheight = position.height;
    selectArea.x = position.x1;
    selectArea.y = position.y1;
  }

  function handleUpload (e) {
    e.preventDefault();
    if (!$("#upload_button").val()) {
    //if (selectArea.cropwidth === 0 && selectArea.cropheight === 0) {
      $message.html("请选择图片区域").show();
    } else {
      // createInputForAvatarInformation();
      $("form#avatar_form").submit();
    }
  }

  function createInputForAvatarInformation () {
    var str = "";
    for (attr in selectArea) {
      str += "<input type='hidden' name='" + attr + "' value='" + selectArea[attr] + "' />"
    }
    str += "<input type='hidden' name='width' value='" + $avatar.css("width").slice(0, -2) + "' />";
    str += "<input type='hidden' name='height' value='" + $avatar.css("height").slice(0, -2) + "' />";
    $("#upload_button").parent().append(str);
  }

  $('#upload_button').bind("change", handleFileSelect);
  $('#avatar_submit').bind("click", handleUpload);
});
