module.exports = {
  env: {
    commonjs: true,
    es2021: true,
    node: true,
  },
  extends: ['airbnb-base'],
  overrides: [
    {
      files: ['*.md'],
      parser: 'eslint-plugin-markdownlint/parser',
      extends: ['plugin:markdownlint/recommended'],
      rules: {
        'markdownlint/md001': 'off',
        'markdownlint/md003': 'warn',
        'markdownlint/md025': [
          'error',
          {
            level: 2,
          },
        ],
        'markdownlint/md013': 'off',
      },
    },
  ],
  parserOptions: {
    ecmaVersion: 'latest',
  },
  rules: {},
};
