prompt_jj_vcs() {
    pwd_in_jjgit() {
        local D="/$PWD"
        while test -n "$D" ; do
          test -e "$D/.jj" && { echo jj ; return; }
          test -e "$D/.git" && { echo git ; return; }
          D="${D%/*}"
        done
    }
    local jjgit="`pwd_in_jjgit`"
    if test "$jjgit" = jj ; then
      # --ignore-working-copy: avoid inspecting $PWD and concurrent snapshotting which could create divergent commits
      text=$(jj --ignore-working-copy --no-pager log --no-graph --color=always -r @ -T \
         ' "%F{blue}jj:[%f%F{white}@%f " ++ concat( separate(" ", format_short_change_id_with_hidden_and_divergent_info(self),
          bookmarks, if(conflict, label("conflict", "conflict")) ) ) ++ "%F{blue}]%f\n" ' 2>/dev/null)
      p10k segment -t ${text}
    fi
}
