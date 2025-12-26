#!/bin/bash

# Check for project name
if [ -z "$1" ]; then
  echo "Please provide a project name."
  exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="./$PROJECT_NAME"

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# Create package.json
cat <<EOF > package.json
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "",
  "source": "index.html",
  "scripts": {
    "start": "parcel index.html",
    "build": "parcel build index.html"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "module",
  "devDependencies": {
    "parcel": "latest"
  },
  "dependencies": {}
}
EOF

# Create directory structure
mkdir -p src/components src/pages src/assets/styles

# Create index.html
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <title>$PROJECT_NAME</title>
    <link rel="stylesheet" href="./src/assets/styles/main.scss">
</head>
<body>
    <script type="module" src="./src/index.ts"></script>
</body>
</html>
EOF

# Create index.ts
cat <<EOF > src/index.ts
import { handleLocation, navigate } from './router';

window.addEventListener('popstate', handleLocation);
document.addEventListener('DOMContentLoaded', () => {
    document.body.addEventListener('click', e => {
        if (e.target && (e.target as HTMLElement).matches('[data-link]')) {
            e.preventDefault();
            navigate((e.target as HTMLAnchorElement).href);
        }
    });
    handleLocation();
});
EOF

# Create router.ts
cat <<EOF > src/router.ts
import { HomePage } from './pages/HomePage';
import { AboutPage } from './pages/AboutPage';

const routes = {
    '/': HomePage,
    '/about': AboutPage,
};

export function handleLocation() {
    const path = window.location.pathname;
    const page = routes[path] || routes['/']; // Default to home page
    document.body.innerHTML = '';
    document.body.appendChild(page());
}

export function navigate(path: string) {
    window.history.pushState({}, '', path);
    handleLocation();
}
EOF

# Create main.scss
cat <<EOF > src/assets/styles/main.scss
body {
    background-color: #f0f0f0;
    font-family: sans-serif;

    h1 {
        color: #333;
    }
}

.btn {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    font-size: 16px;

    &:hover {
        background-color: #0056b3;
    }
}
EOF

# Create Button.ts
cat <<EOF > src/components/Button.ts
export function Button(text: string, onClick: () => void): HTMLButtonElement {
    const button = document.createElement('button');
    button.textContent = text;
    button.onclick = onClick;
    button.classList.add('btn');
    return button;
}
EOF

# Create HomePage.ts
cat <<EOF > src/pages/HomePage.ts
import { Button } from '../components/Button';

export function HomePage(): HTMLElement {
    const container = document.createElement('div');
    container.classList.add('home-page');

    const heading = document.createElement('h1');
    heading.textContent = 'Welcome to the Home Page';

    const myButton = Button('Click me!', () => {
        alert('Button clicked!');
    });

    const link = document.createElement('a');
    link.href = '/about';
    link.textContent = 'Go to About Page';
    link.setAttribute('data-link', '');

    container.appendChild(heading);
    container.appendChild(myButton);
    container.appendChild(link);

    return container;
}
EOF

# Create AboutPage.ts
cat <<EOF > src/pages/AboutPage.ts
export function AboutPage(): HTMLElement {
    const container = document.createElement('div');
    container.classList.add('about-page');

    const heading = document.createElement('h1');
    heading.textContent = 'About Us';

    const paragraph = document.createElement('p');
    paragraph.textContent = 'This is the about page. Add your content here.';
    
    const link = document.createElement('a');
    link.href = '/';
    link.textContent = 'Go to Home Page';
    link.setAttribute('data-link', '');

    container.appendChild(heading);
    container.appendChild(paragraph);
    container.appendChild(link);

    return container;
}
EOF

# Install dependencies
echo "Installing dependencies..."
npm install

echo "Project '$PROJECT_NAME' created successfully."
echo "To start the development server, run:"
echo "cd $PROJECT_NAME"
echo "npm run start"
