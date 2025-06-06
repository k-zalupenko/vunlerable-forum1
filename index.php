<?php
$conn = new mysqli("127.0.0.1", "root", "rootpass", "forum");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $content = $_POST['content'];

    $filename = '';
    if (!empty($_FILES['file']['name'])) {
        $filename = basename($_FILES['file']['name']);
        move_uploaded_file($_FILES['file']['tmp_name'], "uploads/" . $filename); // Vulnerable, as requested
    }

    $stmt = $conn->prepare("INSERT INTO posts (username, content, attachment) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $content, $filename);
    $stmt->execute();

    header("Location: " . $_SERVER['PHP_SELF']);
    exit();
}

// Pagination and filtering logic
$limit = 10;
$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
$start = ($page - 1) * $limit;

$filter = "";
if (!empty($_GET['username']) || !empty($_GET['q'])) {
    $filter = "WHERE 1=1 ";
    if (!empty($_GET['username'])) {
        $filter .= "AND username = '" . $_GET['username'] . "' "; // SQLi here, as requested
    }
    if (!empty($_GET['q'])) {
        $filter .= "AND content LIKE '%" . $_GET['q'] . "%' "; // SQLi here, as requested
    }
}

$query = "SELECT * FROM posts $filter ORDER BY created_at DESC LIMIT $start, $limit";
$result = $conn->query($query);
?>


<!DOCTYPE html>
<html>
<head>
    <title>Anonymous vulnerable Forum</title>
</head>
<body>
    <h1>Anonymous vulnerable Forum</h1>

    <!-- Post creation form -->
    <h2>Create a New Post</h2>
    <form method="POST" enctype="multipart/form-data">
        Username: <input type="text" name="username" required><br><br>
        Content:<br>
        <textarea name="content" rows="5" cols="50" required></textarea><br><br>
        Attachment: <input type="file" name="file"><br><br>
        <button type="submit">Post</button>
    </form>

    <hr>
    <hr>

    <!-- Filter form -->
    <form method="GET">
        Filter by username: <input type="text" name="username" value="<?= htmlspecialchars($_GET['username'] ?? '') ?>" />
        Text: <input type="text" name="q" value="<?= htmlspecialchars($_GET['q'] ?? '') ?>" />
        <button type="submit">Search</button>
    </form>

    <hr>

    <!-- Posts list -->
    <?php while ($row = $result->fetch_assoc()): ?>
        <div>
            <strong><?= htmlspecialchars($row['username'] ?? '') ?></strong><br>
            <?= $row['content'] ?><br>
            <?php if ($row['attachment']): ?>
                <a href="uploads/<?= htmlspecialchars($row['attachment'] ?? '') ?>">Attachment</a>
            <?php endif; ?>
        </div>
        <hr>
    <?php endwhile; ?>

    <div>
        <?php if ($page > 1): ?>
            <a href="?page=<?= $page - 1 ?>&username=<?= urlencode($_GET['username'] ?? '') ?>&q=<?= urlencode($_GET['q'] ?? '') ?>">Prev</a>
        <?php else: ?>
            Prev
        <?php endif; ?>
         | 
        <a href="?page=<?= $page + 1 ?>&username=<?= urlencode($_GET['username'] ?? '') ?>&q=<?= urlencode($_GET['q'] ?? '') ?>">Next</a>
    </div>
</body>
</html>
