// ==========================================================================
// Milgaya - Frontend JavaScript Helpers
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {

    // 1. Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });

    // 2. Demo credentials auto-fill helper for login page
    window.fillDemoCredentials = (role) => {
        const emailInput = document.getElementById('loginEmail');
        const passInput = document.getElementById('loginPassword');
        if (!emailInput || !passInput) return;

        if (role === 'admin') {
            emailInput.value = 'admin@milgaya.com';
            passInput.value = 'admin123';
        } else if (role === 'user') {
            emailInput.value = 'rahul@example.com';
            passInput.value = 'user123';
        }
    };

    // 3. Category image preset selector on report forms
    const categorySelect = document.getElementById('itemCategorySelect');
    const imageUrlInput = document.getElementById('itemImageUrl');
    const imagePreview = document.getElementById('imagePreview');

    const sampleImages = {
        '1': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600&auto=format&fit=crop&q=80', // Electronics
        '2': 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80', // Wallet
        '3': 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80', // Documents
        '4': 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop&q=80', // Keys
        '5': 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=600&auto=format&fit=crop&q=80', // Pets
        '6': 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80', // Jewelry
        '7': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80', // Clothing
        '8': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80', // Books
        '9': 'https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80'  // Other
    };

    if (categorySelect && imageUrlInput) {
        categorySelect.addEventListener('change', () => {
            const catId = categorySelect.value;
            if (catId && (!imageUrlInput.value || Object.values(sampleImages).includes(imageUrlInput.value))) {
                if (sampleImages[catId]) {
                    imageUrlInput.value = sampleImages[catId];
                    if (imagePreview) {
                        imagePreview.src = sampleImages[catId];
                        imagePreview.style.display = 'block';
                    }
                }
            }
        });

        if (imageUrlInput) {
            imageUrlInput.addEventListener('input', () => {
                if (imagePreview) {
                    if (imageUrlInput.value) {
                        imagePreview.src = imageUrlInput.value;
                        imagePreview.style.display = 'block';
                    } else {
                        imagePreview.style.display = 'none';
                    }
                }
            });
        }
    }

    // 4. Copy shareable link
    window.copyShareLink = (url) => {
        navigator.clipboard.writeText(url).then(() => {
            alert('Item link copied to clipboard!');
        }).catch(() => {
            prompt('Copy item URL:', url);
        });
    };
});
