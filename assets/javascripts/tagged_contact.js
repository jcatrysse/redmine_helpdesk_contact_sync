function formatStateWithAvatarHcs(opt) {
  return $('<span>' + opt.avatar + '&nbsp;' + opt.text + opt.tags + '</span>');
};

function formatStateWithMultiaddressHcs(opt) {
  return $('<span class="select2-contact">' + opt.avatar + '<p class="select2-contact__name">' + opt.text + opt.tags + '</p><p class="select2-contact__email">' + opt.email + '</p></span>');
}
