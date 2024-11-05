import { ajax } from "discourse/lib/ajax";
import { apiInitializer } from "discourse/lib/api";
import LocaleSelector from "../components/locale-selector";

export default apiInitializer("1.28.0", (api) => {
  const siteSettings = api.container.lookup("site-settings:main");
  const currentUser = api.getCurrentUser();

  if (currentUser && siteSettings.allow_user_locale) {
    api.headerIcons.add(
      "locale-selector",
      <template>
        <li class="header-locale-selector-widget"><LocaleSelector /></li>
      </template>,
      {
        before: api.headerIcons.has("chat") ? "chat" : "search",
      }
    );

    api.reopenWidget("post-menu", {
      didRenderWidget() {
        if (!this.attrs.can_translate) {
          return;
        }

        if (this.state.isTranslated) {
          return;
        }

        if (this.state.isTranslating) {
          return;
        }

        if (this.state.translateError) {
          return;
        }

        this.state.isTranslated = true;
        this.state.isTranslating = true;
        this.scheduleRerender();

      },
    });
  }
});
