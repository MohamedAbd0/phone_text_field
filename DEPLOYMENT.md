# 🚀 GitHub Pages Deployment Setup

This guide explains how to deploy the Phone Text Field demo to GitHub Pages using GitHub Actions.

## 📋 Prerequisites

1. **GitHub Repository**: Ensure your code is pushed to GitHub
2. **GitHub Pages**: Enable GitHub Pages in repository settings
3. **Workflow Permissions**: Set proper workflow permissions

## ⚙️ Setup Instructions

### 1. Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select **GitHub Actions**
4. Save the settings

### 2. Configure Workflow Permissions

1. Go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select:
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
3. Save the settings

### 3. Deploy the Demo

The GitHub Action will automatically trigger when you:
- Push to the `main` branch
- Create a pull request
- Manually trigger via **Actions** tab

## 🌐 Access Your Demo

After successful deployment, your demo will be available at:
```
https://yourusername.github.io/phone_text_field/
```

## 🔧 Workflow Features

The deployment workflow includes:

- ✅ **Flutter Setup**: Latest stable Flutter version
- ✅ **Code Analysis**: `flutter analyze` for code quality
- ✅ **Testing**: `flutter test` for reliability
- ✅ **Web Build**: Optimized production build
- ✅ **GitHub Pages**: Automatic deployment

## 📱 Build Configuration

The workflow builds the Flutter web app with:
- **Base href**: `/phone_text_field/` for GitHub Pages
- **Release mode**: Optimized for production
- **Web renderer**: Auto (uses CanvasKit when beneficial)

## 🛠️ Customization

### Change Base URL
If your repository name is different, update the workflow:
```yaml
flutter build web --release --base-href="/your-repo-name/"
```

### Update Flutter Version
Modify the workflow file to use a specific Flutter version:
```yaml
flutter-version: '3.24.0'  # Change to desired version
```

## 📊 Monitoring

Monitor deployment status:
1. Go to **Actions** tab in your repository
2. Check the latest workflow run
3. View logs for any issues

## 🔍 Troubleshooting

### Common Issues

1. **Permission Denied**
   - Check workflow permissions in Settings → Actions

2. **Build Fails**
   - Check Flutter version compatibility
   - Ensure all dependencies are available

3. **Page Not Loading**
   - Verify base href configuration
   - Check browser console for errors

### Debug Steps

1. Check the workflow logs in Actions tab
2. Verify GitHub Pages settings
3. Test the build locally:
   ```bash
   cd example
   flutter build web --release
   ```

## 🎯 Next Steps

After successful deployment:
- ✅ Update README.md with your demo URL
- ✅ Share the demo link on pub.dev
- ✅ Add the URL to your repository description
- ✅ Include in your package documentation

---

**Happy Deploying!** 🚀
