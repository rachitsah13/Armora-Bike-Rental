<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>About Us | Armora Bike Rentals</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .team-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 2.5rem;
                margin-top: 4rem;
            }

            .team-card {
                background: var(--surface-color);
                border-radius: 20px;
                overflow: hidden;
                border: 1px solid var(--border-color);
                transition: var(--transition);
                position: relative;
            }

            .team-card:hover {
                transform: translateY(-10px);
                border-color: var(--primary-color);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            }

            .member-img {
                width: 100%;
                height: 350px;
                object-fit: cover;
                border-bottom: 1px solid var(--border-color);
            }

            .member-info {
                padding: 2rem;
            }

            .member-role {
                display: inline-block;
                padding: 0.4rem 1rem;
                background: rgba(56, 189, 248, 0.1);
                color: var(--primary-color);
                border-radius: 50px;
                font-size: 0.85rem;
                font-weight: 800;
                text-transform: uppercase;
                margin-bottom: 1rem;
            }

            .member-name {
                font-size: 1.5rem;
                color: white;
                margin-bottom: 0.5rem;
            }

            .member-details {
                color: var(--text-secondary);
                font-size: 0.95rem;
                margin-bottom: 1.5rem;
                line-height: 1.8;
            }

            .member-socials {
                display: flex;
                gap: 1rem;
            }

            .social-link {
                padding: 0.6rem 1.2rem;
                border-radius: 8px;
                background: rgba(15, 23, 42, 0.6);
                color: var(--text-primary);
                text-decoration: none;
                font-size: 0.9rem;
                font-weight: 600;
                border: 1px solid var(--border-color);
                transition: var(--transition);
            }

            .social-link:hover {
                background: var(--primary-color);
                color: #0f172a;
                border-color: var(--primary-color);
            }

            /* Modal overlay styling */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(15, 23, 42, 0.75);
                backdrop-filter: blur(12px);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 2000;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
            }

            .modal-overlay.active {
                opacity: 1;
                pointer-events: auto;
            }

            .modal-content {
                background: var(--surface-color);
                border: 1px solid var(--border-color);
                border-radius: 24px;
                width: 90%;
                max-width: 550px;
                padding: 2.5rem;
                position: relative;
                transform: translateY(30px);
                transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            }

            .modal-overlay.active .modal-content {
                transform: translateY(0);
            }

            .modal-close {
                position: absolute;
                top: 1.5rem;
                right: 1.5rem;
                background: rgba(15, 23, 42, 0.4);
                border: 1px solid var(--border-color);
                color: var(--text-secondary);
                font-size: 1.5rem;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: var(--transition);
            }

            .modal-close:hover {
                background: var(--accent-color);
                color: white;
                border-color: var(--accent-color);
                transform: rotate(90deg);
            }

            .modal-title {
                font-size: 1.75rem;
                font-weight: 800;
                color: white;
                margin-bottom: 2rem;
                text-align: center;
                background: linear-gradient(135deg, white, var(--primary-color));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            /* Custom form components inside the modal */
            .form-row {
                display: flex;
                gap: 1.25rem;
                margin-bottom: 1.25rem;
            }

            .form-row .form-group-custom {
                flex: 1;
            }

            .form-group-custom {
                margin-bottom: 1.25rem;
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .form-group-custom label {
                font-weight: 600;
                color: var(--text-secondary);
                font-size: 0.9rem;
            }

            .form-group-custom input {
                width: 100%;
                padding: 0.85rem 1rem;
                border-radius: 10px;
                background: rgba(15, 23, 42, 0.6);
                border: 1px solid var(--border-color);
                color: white;
                font-size: 0.95rem;
                transition: var(--transition);
            }

            .form-group-custom input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.2);
                outline: none;
            }

            /* File upload area */
            .file-upload-zone {
                border: 2px dashed var(--border-color);
                border-radius: 12px;
                padding: 1.5rem;
                text-align: center;
                cursor: pointer;
                background: rgba(15, 23, 42, 0.4);
                transition: var(--transition);
                position: relative;
                overflow: hidden;
                min-height: 120px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .file-upload-zone:hover {
                border-color: var(--primary-color);
                background: rgba(56, 189, 248, 0.02);
            }

            .upload-placeholder {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 0.5rem;
            }

            .upload-icon {
                font-size: 2rem;
                color: var(--text-secondary);
                line-height: 1;
            }

            .upload-placeholder p {
                font-size: 0.85rem;
                color: var(--text-secondary);
            }

            .photo-preview {
                width: 100%;
                height: 120px;
                object-fit: cover;
                border-radius: 8px;
                position: absolute;
                top: 0;
                left: 0;
            }

            /* Custom card delete button overlay */
            .custom-member-card {
                position: relative;
            }

            .delete-member-btn {
                position: absolute;
                top: 1rem;
                right: 1rem;
                background: rgba(244, 63, 94, 0.2);
                border: 1px solid var(--accent-color);
                color: var(--accent-color);
                padding: 0.4rem 0.8rem;
                border-radius: 8px;
                font-size: 0.8rem;
                font-weight: 700;
                cursor: pointer;
                transition: var(--transition);
                z-index: 10;
                backdrop-filter: blur(4px);
                opacity: 0;
                transform: translateY(-5px);
            }

            .team-card:hover .delete-member-btn {
                opacity: 1;
                transform: translateY(0);
            }

            .delete-member-btn:hover {
                background: var(--accent-color);
                color: white;
            }
        </style>
    </head>

    <body>
        <nav class="navbar">
            <a href="index.jsp" class="logo">
                <img src="images/logo.png" alt="Armora Bike Rentals logo">
                <span class="logo-text">Armora <span>Bikes</span></span>
            </a>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="about.jsp" class="active">About</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
            <div class="auth-buttons">
                <a href="login.jsp" class="btn btn-outline">Log In</a>
                <a href="register.jsp" class="btn btn-primary">Sign Up</a>
            </div>
        </nav>

        <main style="flex: 1; padding: 5rem 5%;">
            <div style="max-width: 1200px; margin: 0 auto;">
                <div style="text-align: center; max-width: 800px; margin: 0 auto 5rem auto;">
                    <h1 style="color: var(--primary-color); font-size: 3.5rem; margin-bottom: 2rem;">Meet Our Team</h1>
                    <p style="font-size: 1.2rem; color: var(--text-secondary); line-height: 1.8;">
                        The visionaries behind Armora Bike Rentals. We are a group of students and enthusiasts dedicated
                        to creating a
                        seamless bike rental experience for our community.
                    </p>
                </div>

                <div class="team-grid">
                    <!-- Our Leader -->
                    <div class="team-card">
                        <img src="${pageContext.request.contextPath}/images/about/Rachit.jpeg" alt="Rachit Sah" class="member-img">
                        <div class="member-info">
                            <span class="member-role">Our Leader</span>
                            <h2 class="member-name">Rachit Sah</h2>
                            <div class="member-details">
                                <strong>Age:</strong> 19<br>
                                <strong>Contact:</strong> 9766121811<br>
                                <strong>College ID:</strong> 24046829
                            </div>
                            <div class="member-socials">
                                <a href="https://www.instagram.com/rachitshah.13?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
                                    target="_blank" class="social-link">Instagram</a>
                            </div>
                        </div>
                    </div>

                    <!-- Our CO-LEADER -->
                    <div class="team-card">
                        <img src="${pageContext.request.contextPath}/images/about/Subham.jpeg" alt="Subham Manandhar" class="member-img">
                        <div class="member-info">
                            <span class="member-role"
                                style="background: rgba(129, 140, 248, 0.1); color: var(--secondary-color);">Our
                                CO-LEADER</span>
                            <h2 class="member-name">Subham Manandhar</h2>
                            <div class="member-details">
                                <strong>Age:</strong> 20<br>
                                <strong>Contact:</strong> 9823553023<br>
                                <strong>College ID:</strong> N/A
                            </div>
                            <div class="member-socials">
                                <a href="https://www.instagram.com/tsi_strange?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
                                    target="_blank" class="social-link">Instagram</a>
                            </div>
                        </div>
                    </div>

                    <!-- Developer -->
                    <div class="team-card">
                        <img src="${pageContext.request.contextPath}/images/about/Shaswat.jpeg" alt="Shaswat Agrawal" class="member-img">
                        <div class="member-info">
                            <span class="member-role"
                                style="background: rgba(244, 63, 94, 0.1); color: var(--accent-color);">Developer</span>
                            <h2 class="member-name">Shaswat Agrawal</h2>
                            <div class="member-details">
                                <strong>Age:</strong> 21<br>
                                <strong>Contact:</strong> 9820742290<br>
                                <strong>College ID:</strong> 24046883
                            </div>
                            <div class="member-socials">
                                <a href="https://www.instagram.com/shaswat.agrawal.7923?igsh=MWpuNnF2b2JndHNtbA%3D%3D&utm_source=qr"
                                    target="_blank" class="social-link">Instagram</a>
                                <a href="https://guns.lol/shaswat" target="_blank" class="social-link">Guns.lol</a>
                            </div>
                        </div>
                    </div>

                    <!-- Operations Manager -->
                    <div class="team-card">
                        <img src="${pageContext.request.contextPath}/images/about/manjeet.jpeg" alt="Manjeet Budhathoki" class="member-img">
                        <div class="member-info">
                            <span class="member-role"
                                style="background: rgba(34, 197, 94, 0.1); color: #22c55e;">Operations Manager</span>
                            <h2 class="member-name">Manjeet Budhathoki</h2>
                            <div class="member-details">
                                <strong>Age:</strong> 27<br>
                                <strong>Contact:</strong> 9807945627<br>
                                <strong>College ID:</strong> 24046945
                            </div>
                            <div class="member-socials">
                                <a href="https://www.instagram.com/manzeet_jung?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
                                    target="_blank" class="social-link">Instagram</a>
                            </div>
                        </div>
                    </div>

                    <!-- Empty Template / Future Member -->
                    <div class="team-card" id="join-team-card"
                        style="display: flex; align-items: center; justify-content: center; min-height: 500px; border: 2px dashed var(--border-color); background: transparent; cursor: pointer;">
                        <div style="text-align: center; padding: 2rem;">
                            <div style="font-size: 3rem; color: var(--text-secondary); margin-bottom: 1rem;">+</div>
                            <h2 class="member-name" style="color: var(--text-secondary);">Join Our Team</h2>
                            <p style="color: var(--text-secondary);">We are always looking for passionate individuals.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer>
            <p>&copy; 2026 Armora Bike Rentals (ABR). All rights reserved.</p>
        </footer>

        <!-- Add Member Modal -->
        <div id="addMemberModal" class="modal-overlay">
            <div class="modal-content">
                <button class="modal-close" id="closeModalBtn">&times;</button>
                <h3 class="modal-title">Add Team Member</h3>
                <form id="addMemberForm">
                    <div class="form-group-custom">
                        <label>Profile Picture</label>
                        <div class="file-upload-zone" id="fileUploadZone">
                            <input type="file" id="memberPhoto" accept="image/*" style="display: none;">
                            <div class="upload-placeholder">
                                <div class="upload-icon">+</div>
                                <p>Click or drag image to upload</p>
                            </div>
                            <img id="photoPreview" class="photo-preview" style="display: none;" alt="Preview">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group-custom">
                            <label for="memberName">Full Name *</label>
                            <input type="text" id="memberName" required placeholder="e.g. John Doe">
                        </div>
                        <div class="form-group-custom">
                            <label for="memberRole">Role / Position *</label>
                            <input type="text" id="memberRole" required placeholder="e.g. Lead Designer">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group-custom">
                            <label for="memberAge">Age *</label>
                            <input type="number" id="memberAge" min="1" max="120" required placeholder="e.g. 21">
                        </div>
                        <div class="form-group-custom">
                            <label for="memberContact">Contact *</label>
                            <input type="text" id="memberContact" required placeholder="e.g. 9812345678">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group-custom">
                            <label for="memberCollegeId">College ID</label>
                            <input type="text" id="memberCollegeId" placeholder="e.g. 24046883 (or N/A)">
                        </div>
                        <div class="form-group-custom">
                            <label for="memberInstagram">Instagram Link</label>
                            <input type="url" id="memberInstagram" placeholder="https://instagram.com/...">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Add Member</button>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const modal = document.getElementById('addMemberModal');
                const openBtn = document.getElementById('join-team-card');
                const closeBtn = document.getElementById('closeModalBtn');
                const form = document.getElementById('addMemberForm');
                const fileZone = document.getElementById('fileUploadZone');
                const fileInput = document.getElementById('memberPhoto');
                const photoPreview = document.getElementById('photoPreview');
                const uploadPlaceholder = fileZone.querySelector('.upload-placeholder');
                const teamGrid = document.querySelector('.team-grid');
                
                let base64Image = '';

                // Open Modal
                openBtn.addEventListener('click', () => {
                    modal.classList.add('active');
                    document.body.style.overflow = 'hidden';
                });

                // Close Modal
                const closeModal = () => {
                    modal.classList.remove('active');
                    document.body.style.overflow = '';
                    form.reset();
                    base64Image = '';
                    photoPreview.style.display = 'none';
                    uploadPlaceholder.style.display = 'flex';
                };
                closeBtn.addEventListener('click', closeModal);
                modal.addEventListener('click', (e) => {
                    if (e.target === modal) closeModal();
                });

                // File upload triggers
                fileZone.addEventListener('click', () => fileInput.click());
                
                // Drag & Drop
                fileZone.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    fileZone.style.borderColor = 'var(--primary-color)';
                });
                
                fileZone.addEventListener('dragleave', () => {
                    fileZone.style.borderColor = 'var(--border-color)';
                });
                
                fileZone.addEventListener('drop', (e) => {
                    e.preventDefault();
                    fileZone.style.borderColor = 'var(--border-color)';
                    if (e.dataTransfer.files.length > 0) {
                        handleFile(e.dataTransfer.files[0]);
                    }
                });

                fileInput.addEventListener('change', (e) => {
                    if (e.target.files.length > 0) {
                        handleFile(e.target.files[0]);
                    }
                });

                function handleFile(file) {
                    if (!file.type.startsWith('image/')) {
                        alert('Please select an image file.');
                        return;
                    }
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        base64Image = e.target.result;
                        photoPreview.src = base64Image;
                        photoPreview.style.display = 'block';
                        uploadPlaceholder.style.display = 'none';
                    };
                    reader.readAsDataURL(file);
                }

                // Default Avatar helper with nice gradient representation
                function getDefaultAvatar(name) {
                    const colors = ['#38bdf8', '#818cf8', '#f43f5e', '#34d399', '#fbbf24'];
                    let hash = 0;
                    for (let i = 0; i < name.length; i++) {
                        hash = name.charCodeAt(i) + ((hash << 5) - hash);
                    }
                    const color = colors[Math.abs(hash) % colors.length];
                    const initials = name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
                    
                    const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="100%" height="100%">
                        <rect width="100%" height="100%" fill="#1e293b"/>
                        <circle cx="100" cy="100" r="70" fill="\${color}" opacity="0.15"/>
                        <text x="50%" y="54%" font-family="'Outfit', sans-serif" font-weight="800" font-size="64px" fill="\${color}" dominant-baseline="middle" text-anchor="middle">\${initials}</text>
                    </svg>`;
                    return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg);
                }

                const customMembersKey = 'armora_custom_team_members';
                
                function getCustomMembers() {
                    const data = localStorage.getItem(customMembersKey);
                    return data ? JSON.parse(data) : [];
                }
                
                function saveCustomMembers(members) {
                    localStorage.setItem(customMembersKey, JSON.stringify(members));
                }

                // Role badge color mapping matching the theme palette
                const badgeStyles = [
                    { bg: 'rgba(56, 189, 248, 0.1)', color: 'var(--primary-color)' },
                    { bg: 'rgba(129, 140, 248, 0.1)', color: 'var(--secondary-color)' },
                    { bg: 'rgba(244, 63, 94, 0.1)', color: 'var(--accent-color)' },
                    { bg: 'rgba(34, 197, 94, 0.1)', color: '#22c55e' }
                ];

                // Load and Render
                function renderMembers() {
                    document.querySelectorAll('.custom-member-card').forEach(card => card.remove());

                    const members = getCustomMembers();
                    members.forEach((member, index) => {
                        const card = document.createElement('div');
                        card.className = 'team-card custom-member-card';
                        card.style.opacity = '0';
                        card.style.transform = 'translateY(20px)';
                        card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                        
                        const imgSrc = member.image || getDefaultAvatar(member.name);
                        const styleIdx = index % badgeStyles.length;
                        const badgeStyle = badgeStyles[styleIdx];

                        card.innerHTML = `
                            <button class="delete-member-btn" data-index="\${index}">Delete</button>
                            <img src="\${imgSrc}" alt="\${member.name}" class="member-img">
                            <div class="member-info">
                                <span class="member-role" style="background: \${badgeStyle.bg}; color: \${badgeStyle.color};">\${member.role}</span>
                                <h2 class="member-name">\${member.name}</h2>
                                <div class="member-details">
                                    <strong>Age:</strong> \${member.age}<br>
                                    <strong>Contact:</strong> \${member.contact}<br>
                                    <strong>College ID:</strong> \${member.collegeId || 'N/A'}
                                </div>
                                \${member.instagram ? `
                                <div class="member-socials">
                                    <a href="\${member.instagram}" target="_blank" class="social-link">Instagram</a>
                                </div>` : ''}
                            </div>
                        `;

                        teamGrid.insertBefore(card, openBtn);
                        
                        setTimeout(() => {
                            card.style.opacity = '1';
                            card.style.transform = 'translateY(0)';
                        }, 50 * index);
                    });

                    // Add delete event listeners
                    document.querySelectorAll('.delete-member-btn').forEach(btn => {
                        btn.addEventListener('click', (e) => {
                            e.stopPropagation();
                            const idx = parseInt(e.target.getAttribute('data-index'));
                            deleteMember(idx);
                        });
                    });
                }

                function deleteMember(idx) {
                    if (confirm('Are you sure you want to remove this team member?')) {
                        const members = getCustomMembers();
                        members.splice(idx, 1);
                        saveCustomMembers(members);
                        renderMembers();
                    }
                }

                // Form Submission
                form.addEventListener('submit', (e) => {
                    e.preventDefault();

                    const name = document.getElementById('memberName').value.trim();
                    const role = document.getElementById('memberRole').value.trim();
                    const age = document.getElementById('memberAge').value.trim();
                    const contact = document.getElementById('memberContact').value.trim();
                    const collegeId = document.getElementById('memberCollegeId').value.trim() || 'N/A';
                    const instagram = document.getElementById('memberInstagram').value.trim();

                    const newMember = {
                        name,
                        role,
                        age,
                        contact,
                        collegeId,
                        instagram,
                        image: base64Image
                    };

                    const members = getCustomMembers();
                    members.push(newMember);
                    saveCustomMembers(members);
                    
                    closeModal();
                    renderMembers();
                });

                // Initial render
                renderMembers();
            });
        </script>
    </body>

    </html>