const routes = [
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      { path: "", redirect: { name: "IndexPage" } },
      {
        path: "/index",
        name: "IndexPage",
        component: () => import("pages/IndexPage.vue"),
      },
      // { path: "", redirect: { name: "HomePage" } },
      // {
      //   path: "/home",
      //   name: "HomePage",
      //   component: () => import("pages/HomePage.vue"),
      // },
      // {
      //   path: "/landing",
      //   name: "LandingPage",
      //   component: () => import("pages/LandingPage.vue"),
      // },
    ],
  },
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
