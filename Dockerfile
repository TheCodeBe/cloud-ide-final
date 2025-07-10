FROM codercom/code-server:latest

# Install rclone and additional tools
USER root

# Install dependencies first (including unzip for rclone)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    nano \
    htop \
    fuse \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Now install rclone (requires unzip)
RUN curl https://rclone.org/install.sh | bash

# Create workspace directories
RUN mkdir -p /workspace/cloud-files
RUN mkdir -p /workspace/local-projects
RUN mkdir -p /workspace/temp

# Create fuse group and add coder user (if group doesn't exist)
RUN groupadd -f fuse && usermod -a -G fuse coder || true

# Set up permissions for FUSE (needed for rclone mount)
RUN echo 'user_allow_other' >> /etc/fuse.conf

# Switch to coder user
USER coder

# Install Cline extension and other useful extensions
RUN code-server --install-extension saoudrizwan.claude-dev
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension bradlc.vscode-tailwindcss
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension ms-vscode.vscode-json

# Create VS Code settings for better cloud workflow
RUN mkdir -p /home/coder/.local/share/code-server/User
RUN echo '{\n\
  "workbench.startupEditor": "none",\n\
  "files.autoSave": "afterDelay",\n\
  "files.autoSaveDelay": 1000,\n\
  "terminal.integrated.defaultProfile.linux": "bash",\n\
  "workbench.colorTheme": "Dark+ (default dark)",\n\
  "explorer.confirmDelete": false,\n\
  "git.autofetch": true,\n\
  "files.exclude": {\n\
    "**/node_modules": true,\n\
    "**/.git": false\n\
  }\n\
}' > /home/coder/.local/share/code-server/User/settings.json

# Create startup script for cloud storage setup
RUN echo '#!/bin/bash\n\
echo "=== Cloud IDE Workspace ==="\n\
echo "📁 Workspace: /workspace/"\n\
echo "☁️  Cloud files: /workspace/cloud-files/ (configure rclone first)"\n\
echo "💻 Local projects: /workspace/local-projects/"\n\
echo ""\n\
echo "🔧 Quick Setup:"\n\
echo "1. Run: rclone config (to setup cloud storage)"\n\
echo "2. Run: rclone mount your-remote: /workspace/cloud-files --daemon --allow-other --vfs-cache-mode full"\n\
echo "3. Work in /workspace/cloud-files/ for auto-sync!"\n\
echo ""\n\
echo "🤖 AI Assistant: Click Cline icon in sidebar"\n\
echo "📖 Help: See README.md for full setup guide"\n\
echo "==============================="\n\
' > /home/coder/welcome.sh && chmod +x /home/coder/welcome.sh

# Set workspace as default directory
WORKDIR /workspace

# Expose port
EXPOSE 8080

# Start code-server with workspace as default folder
CMD ["/bin/bash", "-c", "/home/coder/welcome.sh && code-server --bind-addr 0.0.0.0:8080 --auth password /workspace"]